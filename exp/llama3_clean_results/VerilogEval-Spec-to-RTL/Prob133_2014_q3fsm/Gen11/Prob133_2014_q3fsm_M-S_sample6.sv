module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] count;
reg w_count;

always @(posedge clk) begin
    if(reset) begin
        count <= 0;
        w_count <= 0;
        z <= 0;
    end
    else begin
        if(count == 0) begin
            if(s) begin
                count <= 1;
                w_count <= 0;
            end
        end
        else if(count < 4) begin
            if(w) begin
                w_count <= w_count + 1;
            end
            count <= count + 1;
        end
        else begin
            z <= (w_count == 2) ? 1 : 0;
            count <= 1;
            w_count <= 0;
        end
    end
end

endmodule