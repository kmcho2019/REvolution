module traffic_light(
    input logic rst_n, clk, pass_request,
    output logic [7:0] clock,
    output logic red, output logic yellow, output logic green
);

    logic [1:0] state;
    logic [7:0] cnt;

    // Traffic Light Controller (TLC)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00; // Initial state: red
            cnt <= 10;
            red <= 1;
            yellow <= 0;
            green <= 0;
        end else begin
            case (state)
                2'b00: begin // Red state
                    if (cnt == 0) begin
                        state <= 2'b10; // Transition to green state
                        cnt <= 60;
                        red <= 0;
                        yellow <= 0;
                        green <= 1;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                2'b01: begin // Yellow state
                    if (cnt == 0) begin
                        state <= 2'b00; // Transition to red state
                        cnt <= 10;
                        red <= 1;
                        yellow <= 0;
                        green <= 0;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                2'b10: begin // Green state
                    if (pass_request && cnt > 10) begin
                        cnt <= 10; // Shorten green state to 10 clocks
                    end
                    if (cnt == 0) begin
                        state <= 2'b01; // Transition to yellow state
                        cnt <= 5;
                        red <= 0;
                        yellow <= 1;
                        green <= 0;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    state <= 2'b00; // Reset to red state
                    cnt <= 10;
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                end
            endcase
        end
    end

    assign clock = cnt;

endmodule