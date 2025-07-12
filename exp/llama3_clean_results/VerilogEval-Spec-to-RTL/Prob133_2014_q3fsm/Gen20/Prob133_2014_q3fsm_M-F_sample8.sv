module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // 1-bit register to store the current state (0: state A, 1: state B)
reg [1:0] count; // 2-bit register to store the count of 'w' being 1
reg [1:0] cycle; // 2-bit register to store the number of clock cycles in state B
reg temp_z; // temporary register to store the value of 'z' for the next clock cycle

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        count <= 0;
        cycle <= 0;
        z <= 0;
    end
    else begin
        if(state == 0) begin
            if(s) begin
                state <= 1;
                cycle <= 1;
                count <= 0;
            end
        end
        else begin
            if(cycle < 3) begin
                cycle <= cycle + 1;
                if(w) begin
                    count <= count + 1;
                end
            end
            else begin
                cycle <= 1;
                if(count == 2) begin
                    temp_z <= 1;
                end
                else begin
                    temp_z <= 0;
                end
                count <= 0;
            end
        end
        z <= temp_z;
    end
end

endmodule