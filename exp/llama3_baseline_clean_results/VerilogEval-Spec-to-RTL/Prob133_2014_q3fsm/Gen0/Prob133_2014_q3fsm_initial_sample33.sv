module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state;
reg [1:0] counter;
reg w_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // State A
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to State B
                    counter <= 1;
                    w_count <= w;
                    z <= 0;
                end else begin
                    state <= 0; // Stay in State A
                    counter <= 0;
                    w_count <= 0;
                    z <= 0;
                end
            end
            1: begin // State B
                if (counter == 3) begin
                    if (w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    state <= 1; // Stay in State B
                    counter <= 1;
                    w_count <= w;
                end else begin
                    state <= 1; // Stay in State B
                    counter <= counter + 1;
                    w_count <= w_count + w;
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule