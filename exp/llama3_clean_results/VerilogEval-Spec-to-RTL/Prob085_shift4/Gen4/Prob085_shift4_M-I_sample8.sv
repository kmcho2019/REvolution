module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

// Using a reg with an initial value to reduce power consumption during reset
reg [3:0] q_reg = 4'b0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else begin
        if (load) begin
            // Load data into the register
            q_reg <= data;
        end else if (ena) begin
            // Perform a right shift operation
            q_reg <= {1'b0, q_reg[3:1]};
        end
        // No need for an else clause here; the register retains its value
    end
end

// Directly assign the output from the register
assign q = q_reg;

endmodule