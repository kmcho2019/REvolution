module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] count;  // 0-3 counter (4 states)
reg [9:0] accum;  // Accumulator (10 bits for sum of 4x8 bits)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        count <= 2'b00;
        accum <= 10'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            case (count)
                2'b00: begin  // First input
                    accum <= data_in;
                    count <= count + 1'b1;
                end
                2'b01, 2'b10: begin  // Second and third inputs
                    accum <= accum + data_in;
                    count <= count + 1'b1;
                end
                2'b11: begin  // Fourth input
                    data_out <= accum + data_in;
                    valid_out <= 1'b1;
                    count <= 2'b00;
                    accum <= 10'b0;
                end
            endcase
        end
    end
end

endmodule