module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // Shift register to store last three values of data_in

// Update shift register on every clock edge
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        shift_reg <= 3'b000;
    end else begin
        shift_reg <= {data_in, shift_reg[2:1]}; // Shift in new data_in value
    end
end

// Combinational logic to generate output based on shift register state
assign data_out = (shift_reg == 3'b010)? 1'b1 : 1'b0;

endmodule