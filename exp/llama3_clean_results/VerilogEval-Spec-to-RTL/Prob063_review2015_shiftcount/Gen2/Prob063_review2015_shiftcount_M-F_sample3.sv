module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] shift_reg;
reg [3:0] count_reg;
reg [3:0] q_reg; // Internal reg for output q

// Initialize the registers
initial begin
    shift_reg = 4'b0000;
    count_reg = 4'b0000;
    q_reg = 4'b0000;
end

// Shift register logic
always @(posedge clk) begin
    if (shift_ena) begin
        shift_reg <= {data, shift_reg[3:1]}; // Shift in the new data
    end else if (count_ena) begin
        if (count_reg == 4'b0000) begin
            count_reg <= 4'b0000; // Handle underflow
        end else begin
            count_reg <= count_reg - 1; // Decrement the counter
        end
    end
end

// Update the output q_reg based on shift_ena and count_ena
always @(posedge clk) begin
    if (shift_ena) begin
        q_reg <= shift_reg; // Prioritize shift operation
    end else if (count_ena) begin
        q_reg <= count_reg; // Update q_reg with counter value if shift_ena is not active
    end
end

// Assign the value of q_reg to output q
assign q = q_reg;

endmodule