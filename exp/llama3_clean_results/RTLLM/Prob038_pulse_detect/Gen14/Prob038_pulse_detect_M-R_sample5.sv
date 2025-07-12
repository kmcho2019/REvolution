module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] data_prev; // Previous values of data_in

// Sequential logic to update previous values
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        data_prev <= 2'b00;
    end else begin
        data_prev <= {data_in, data_prev[0]};
    end
end

// Combinational logic to generate output
assign data_out = (data_prev[0] == 1'b1 && data_prev[1] == 1'b1 && data_in == 1'b0);

endmodule