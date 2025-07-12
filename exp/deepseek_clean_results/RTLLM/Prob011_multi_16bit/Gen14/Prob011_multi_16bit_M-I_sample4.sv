module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    reg [4:0] count;  // Counts 0-16 (5 bits)
    reg [15:0] areg;
    reg [30:0] acc;   // 31-bit accumulator (sufficient for 16x16 mult)
    reg done_reg;
    
    // Pre-compute all possible shifted versions of bin
    wire [31:0] shifted_bin [0:15];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted_bin[i] = bin << i;
        end
    endgenerate

    // Clock gating for accumulator
    wire acc_en = (count > 0 && count < 17) && areg[count-1];
    wire clk_gated = clk & (|count);  // Gate clock when idle

    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            acc <= 31'b0;
        end else if (acc_en) begin
            acc <= acc + shifted_bin[count-1][30:0];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            areg <= 16'b0;
            done_reg <= 1'b0;
        end else begin
            if (start && count == 0) begin
                // Load operands and initialize
                areg <= ain;
                count <= count + 1;
                done_reg <= 1'b0;
            end else if (count > 0 && count < 16) begin
                count <= count + 1;
            end else if (count == 16) begin
                count <= count + 1;
                done_reg <= 1'b1;
            end else begin
                // Idle state
                count <= 5'd0;
                done_reg <= 1'b0;
            end
        end
    end

    // Output assignment with zero extension
    assign yout = {1'b0, acc};
    assign done = done_reg;

endmodule