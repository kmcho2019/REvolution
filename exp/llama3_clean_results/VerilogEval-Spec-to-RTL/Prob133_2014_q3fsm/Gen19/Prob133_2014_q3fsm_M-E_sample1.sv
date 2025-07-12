module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg state; // 1-bit register to store the current state (0: state A, 1: state B)
reg [1:0] count; // 2-bit register to store the count of 'w' being 1
reg [2:0] w_count; // 3-bit register to store the count of 'w' being 1 in the last three cycles

assign z = (count == 2);

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        count <= 0;
        w_count <= 0;
    end
    else begin
        if(state == 0) begin
            if(s) begin
                state <= 1;
            end
        end
        else begin
            if(w_count == 3) begin
                w_count <= 0;
            end
            w_count <= w_count + 1;
            if(w) begin
                count <= count + 1;
            end
            if(w_count == 3) begin
                count <= 0;
            end
        end
    end
end

endmodule