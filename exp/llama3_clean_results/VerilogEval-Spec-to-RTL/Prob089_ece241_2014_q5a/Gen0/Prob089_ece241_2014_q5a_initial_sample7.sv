module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] accumulated_input;
reg first_one_seen;
reg [0:0] state; // 0 for idle, 1 for running
reg [0:0] next_state;
reg [0:0] output;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        accumulated_input <= 0;
        first_one_seen <= 0;
        output <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (~areset) begin
                    state <= 1;
                    accumulated_input <= 0;
                    first_one_seen <= 0;
                    output <= 0;
                end else begin
                    state <= 0;
                    accumulated_input <= 0;
                    first_one_seen <= 0;
                    output <= 0;
                end
            end
            1: begin // running
                if (areset) begin
                    state <= 0;
                    accumulated_input <= 0;
                    first_one_seen <= 0;
                    output <= 0;
                end else begin
                    state <= 1;
                    if (~first_one_seen && x) begin
                        first_one_seen <= 1;
                        output <= 1;
                    end else if (first_one_seen) begin
                        output <= ~x;
                    end else begin
                        output <= 0;
                    end
                end
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

assign z = output;

endmodule