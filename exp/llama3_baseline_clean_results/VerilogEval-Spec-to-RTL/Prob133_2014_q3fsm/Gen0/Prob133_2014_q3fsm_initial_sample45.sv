module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] current_state;
reg [1:0] counter;
reg w_count;

initial begin
    current_state = 0; // State A
    counter = 0;
    w_count = 0;
    z = 0;
end

always @(posedge clk) begin
    if (reset) begin
        current_state = 0; // State A
        counter = 0;
        w_count = 0;
        z = 0;
    end else begin
        case (current_state)
            0: begin // State A
                if (s) begin
                    current_state = 1; // Move to state B
                end
            end
            1: begin // State B
                counter = counter + 1;
                if (w) begin
                    w_count = w_count + 1;
                end
                if (counter == 3) begin
                    if (w_count == 2) begin
                        z = 1;
                    end else begin
                        z = 0;
                    end
                    counter = 0;
                    w_count = 0;
                end else begin
                    z = 0;
                end
            end
        endcase
    end
end

endmodule