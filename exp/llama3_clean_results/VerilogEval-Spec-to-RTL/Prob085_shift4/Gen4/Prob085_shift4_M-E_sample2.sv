module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

// Internal signal to hold the selected data
reg [3:0] selected_data;

// Data multiplexer to select between input data and shift register output
always @(posedge clk or posedge areset) begin
    if (areset) begin
        selected_data <= 4'b0000;
    end else if (load) begin
        selected_data <= data;
    end else if (ena) begin
        selected_data <= {1'b0, selected_data[3:1]};
    end else begin
        selected_data <= selected_data;
    end
end

// Assign the selected data to the output
assign q = selected_data;

endmodule