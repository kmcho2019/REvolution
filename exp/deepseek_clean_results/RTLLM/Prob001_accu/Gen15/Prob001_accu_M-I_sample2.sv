module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [3:0] count;        // One-hot counter (0001, 0010, 0100, 1000)
    reg [9:0] accumulator;  // Running sum
    reg [9:0] accum_reg;    // Registered adder output
    wire [4:0] sum_lsb;     // Lower 4-bit sum with carry
    wire [4:0] sum_msb;     // Upper 4-bit sum with carry
    wire gated_clk;         // Clock gating signal
    
    // Clock gating
    assign gated_clk = clk & (valid_in | !rst_n);

    // Split adder into two 4-bit stages
    assign sum_lsb = accumulator[3:0] + data_in[3:0];
    assign sum_msb = accumulator[7:4] + data_in[7:4] + sum_lsb[4];

    always @(posedge gated_clk) begin
        if (!rst_n) begin
            // Conditional reset
            count <= 4'b0001;
            accumulator <= 10'b0;
            accum_reg <= 10'b0;
        end
        else if (valid_in) begin
            // First adder stage result
            accum_reg <= {sum_msb[3:0], sum_lsb[3:0]};
            
            // Second adder stage (carry propagation)
            accumulator <= {accumulator[9:8] + sum_msb[4], accum_reg[7:0]};
            
            // One-hot counter
            count <= {count[2:0], count[3]};
        end
    end

    // Output logic (non-gated clock)
    always @(posedge clk) begin
        if (!rst_n) begin
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= valid_in & count[3];
            if (count[3] & valid_in) begin
                data_out <= accumulator + data_in;
            end
        end
    end

endmodule