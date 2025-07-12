module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // 0: State A, 1: State B
reg [1:0] counter; // Counter for three-clock cycle window
reg [1:0] w_count; // Count of w over the three-clock cycle window
reg set_z; // Flag to set z in the next clock cycle

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0;
        counter <= 0;
        w_count <= 0;
        set_z <= 0;
        z <= 0;
    end else begin
        if(state == 0) begin // State A
            if(s) begin
                state <= 1;
                counter <= 1;
                w_count <= w ? 1 : 0;
            end
        end else begin // State B
            if(counter < 3) begin
                counter <= counter + 1;
                if(w) begin
                    w_count <= w_count + 1;
                end
            end else begin
                set_z <= (w_count == 2) ? 1 : 0;
                counter <= 1;
                w_count <= w ? 1 : 0;
            end
        end
        z <= (counter == 0 && set_z) ? 1 : 0;
        if(counter == 0) begin
            set_z <= 0;
        end
    end
end

endmodule