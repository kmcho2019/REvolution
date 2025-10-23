module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

reg [3:0] reg_data;
reg [1:0] ptr;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        reg_data <= 4'b0;
        ptr <= 2'b0;
    end
    else if (load) begin
        reg_data <= data;
        ptr <= 2'b0;
    end
    else if (ena) begin
        ptr <= ptr + 1;
    end
end

// Output selection based on pointer
always @(*) begin
    case (ptr)
        2'b00: q = {1'b0, reg_data[3:1]};
        2'b01: q = {2'b0, reg_data[3:2]};
        2'b10: q = {3'b0, reg_data[3]};
        2'b11: q = 4'b0;
    endcase
end

endmodule