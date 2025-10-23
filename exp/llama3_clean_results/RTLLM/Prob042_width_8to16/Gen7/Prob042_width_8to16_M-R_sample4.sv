module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_first; // Register to store the first 8-bit data input
reg       first_valid; // Flag to indicate if the first data is valid

// Sequential Logic for State Machine and Data Storage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_first    <= 8'd0;
        first_valid   <= 1'b0;
    end
    else begin
        if (valid_in) begin
            if (!first_valid) begin
                data_first <= data_in;
                first_valid <= 1'b1;
            end
            else begin
                first_valid <= 1'b0;
            end
        end
    end
end

// Combinational Logic for Output Generation
assign valid_out = first_valid && valid_in;
assign data_out  = {data_first, data_in};

endmodule