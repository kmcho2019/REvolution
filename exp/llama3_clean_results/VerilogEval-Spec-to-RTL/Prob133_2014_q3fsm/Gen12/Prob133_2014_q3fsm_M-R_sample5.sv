module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] cycle_count;
reg w_count;
reg checking;
reg z_next;

always @(posedge clk) begin
    if(reset) begin
        z <= 0;
        checking <= 0;
        w_count <= 0;
        cycle_count <= 0;
    end
    else begin
        if(!checking) begin
            if(s) begin
                checking <= 1;
                w_count <= 0;
                cycle_count <= 1;
            end
        end
        else begin
            if(w) begin
                w_count <= w_count + 1;
            end
            if(cycle_count < 3) begin
                cycle_count <= cycle_count + 1;
            end
            else begin
                checking <= 0;
                z_next <= (w_count == 2) ? 1 : 0;
                cycle_count <= 0;
                w_count <= 0;
            end
        end
    end
end

always @(posedge clk) begin
    if(reset) begin
        z <= 0;
    end
    else if(!checking && z_next) begin
        z <= 1;
    end
    else begin
        z <= 0;
    end
end

endmodule