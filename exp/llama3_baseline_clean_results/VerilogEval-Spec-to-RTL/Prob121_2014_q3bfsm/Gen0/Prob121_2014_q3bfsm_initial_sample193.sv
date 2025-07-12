module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define states
enum logic [2:0] {S000, S001, S010, S011, S100} current_state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= S000;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        S000: begin
            if (!x) begin
                next_state = S000;
            end else begin
                next_state = S001;
            end
            z = 0;
        end
        S001: begin
            if (!x) begin
                next_state = S001;
            end else begin
                next_state = S100;
            end
            z = 0;
        end
        S010: begin
            if (!x) begin
                next_state = S010;
            end else begin
                next_state = S001;
            end
            z = 0;
        end
        S011: begin
            if (!x) begin
                next_state = S001;
            end else begin
                next_state = S010;
            end
            z = 1;
        end
        S100: begin
            if (!x) begin
                next_state = S011;
            end else begin
                next_state = S100;
            end
            z = 1;
        end
        default: begin
            next_state = S000;
            z = 0;
        end
    endcase
end

endmodule