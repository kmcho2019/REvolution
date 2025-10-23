module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] reg_out; // Single register for both shift and count operations

// Initialize the register
initial begin
    reg_out = 4'b0000;
end

// Update the register based on control inputs
always @(posedge clk) begin
    if (shift_ena) begin
        // Shift in the new data
        reg_out <= {data, reg_out[3:1]};
    end else if (count_ena) begin
        // Decrement the counter, handling underflow by wrapping around
        if (reg_out == 4'b0000) begin
            reg_out <= 4'b1111; // Maximum value for 4-bit counter
        end else begin
            reg_out <= reg_out - 1;
        end
    end
end

// Assign the value of reg_out to output q
assign q = reg_out;

endmodule