module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_lock;
reg       valid_lock;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'd0;
        valid_lock <= 1'b0;
    end
    else begin
        if (valid_in) begin
            if (!valid_lock) begin
                data_lock <= data_in;
                valid_lock <= 1'b1;
            end
        end
        else begin
            valid_lock <= 1'b0;
        end
    end
end

assign valid_out = valid_lock && valid_in;
assign data_out = {data_lock, data_in};

endmodule