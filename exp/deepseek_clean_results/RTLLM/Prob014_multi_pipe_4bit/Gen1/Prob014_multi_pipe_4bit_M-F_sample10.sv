module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended inputs with size zeros at MSB
    reg [2*size-1:0] ext_a;
    reg [2*size-1:0] ext_b;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ext_a <= 0;
            ext_b <= 0;
        end else begin
            ext_a <= {{size{1'b0}}, mul_a};
            ext_b <= {{size{1'b0}}, mul_b};
        end
    end

    // Pipeline stage 0: Partial product calculation (registered)
    reg [2*size-1:0] pp0, pp1, pp2, pp3;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0 <= 0;
            pp1 <= 0;
            pp2 <= 0;
            pp3 <= 0;
        end else begin
            pp0 <= ext_b[0] ? ext_a : 0;
            pp1 <= ext_b[1] ? (ext_a << 1) : 0;
            pp2 <= ext_b[2] ? (ext_a << 2) : 0;
            pp3 <= ext_b[3] ? (ext_a << 3) : 0;
        end
    end

    // Pipeline stage 1: First level addition
    reg [2*size-1:0] sum01, sum23;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01 <= 0;
            sum23 <= 0;
        end else begin
            sum01 <= pp0 + pp1;
            sum23 <= pp2 + pp3;
        end
    end

    // Pipeline stage 2: Final addition
    reg [2*size-1:0] sum_stage2;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= 0;
        end else begin
            sum_stage2 <= sum01 + sum23;
        end
    end

    // Output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= sum_stage2;
        end
    end

endmodule