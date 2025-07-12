module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp [0:3];
    reg [15:0] sum_reg, carry_reg;
    reg [15:0] result_reg;
    reg [2:0] en_pipeline;

    // Booth encoder signals
    wire [8:0] y_ext = {mul_b, 1'b0};  // Extended multiplier for Booth
    wire [2:0] booth_sel [0:3];

    assign booth_sel[0] = y_ext[2:0];
    assign booth_sel[1] = y_ext[4:2];
    assign booth_sel[2] = y_ext[6:4];
    assign booth_sel[3] = y_ext[8:6];

    // Booth decoder (combinational)
    function [16:0] booth_pp;
        input [7:0] a;
        input [2:0] sel;
        reg [8:0] pp_val;
        reg neg;
    begin
        case (sel)
            3'b000, 3'b111: pp_val = 9'b0;
            3'b001, 3'b010: pp_val = {1'b0, a};
            3'b011:         pp_val = {a, 1'b0};
            3'b100:         pp_val = ~{a, 1'b0};
            3'b101, 3'b110: pp_val = ~{1'b0, a};
        endcase
        neg = sel[2];
        booth_pp = {8{neg}, pp_val} + {15'b0, neg};
    end
    endfunction

    // Partial product compression (4:2 compressor)
    wire [15:0] cout0, cout1;
    wire [15:0] sum0, sum1;

    // Stage 1: Input registration and Booth encoding
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            en_pipeline[0] <= 1'b0;
        end else if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
            en_pipeline[0] <= 1'b1;
        end else begin
            en_pipeline[0] <= 1'b0;
        end
    end

    // Stage 2: Partial product generation and compression
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < 4; i = i+1) pp[i] <= 16'b0;
            sum_reg <= 16'b0;
            carry_reg <= 16'b0;
            en_pipeline[1] <= 1'b0;
        end else if (en_pipeline[0]) begin
            // Generate Booth encoded partial products
            pp[0] <= booth_pp(a_reg, booth_sel[0]);
            pp[1] <= booth_pp(a_reg, booth_sel[1]) << 2;
            pp[2] <= booth_pp(a_reg, booth_sel[2]) << 4;
            pp[3] <= booth_pp(a_reg, booth_sel[3]) << 6;

            // First level compression
            {cout0, sum0} = pp[0] + pp[1];
            {cout1, sum1} = pp[2] + pp[3];
            
            // Register compressed results
            sum_reg <= sum0 + sum1;
            carry_reg <= cout0 + cout1;
            en_pipeline[1] <= 1'b1;
        end else begin
            en_pipeline[1] <= 1'b0;
        end
    end

    // Stage 3: Final addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_reg <= 16'b0;
            en_pipeline[2] <= 1'b0;
        end else if (en_pipeline[1]) begin
            result_reg <= sum_reg + carry_reg;
            en_pipeline[2] <= 1'b1;
        end else begin
            en_pipeline[2] <= 1'b0;
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[2];
    assign mul_out = en_pipeline[2] ? result_reg : 16'b0;

endmodule