module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

reg [3:0] temp_data;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        q <= 4'b0000;
        temp_data <= 4'b0000;
    end else begin
        if(load) begin
            temp_data <= data;
        end else begin
            temp_data <= temp_data;
        end
    end
end

always @(posedge clk) begin
    if(load) begin
        q <= temp_data;
    end else if(ena) begin
        q <= {1'b0, q[3:1]};
    end else begin
        q <= q;
    end
end

endmodule