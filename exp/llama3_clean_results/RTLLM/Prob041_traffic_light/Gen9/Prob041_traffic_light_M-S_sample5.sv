module traffic_light(
    input rst_n, clk, pass_request,
    output [7:0] clock,
    output reg red, output reg yellow, output reg green
);

    reg [1:0] state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b01; // Start with red state
            cnt <= 10;
            red <= 1;
            yellow <= 0;
            green <= 0;
        end else begin
            case (state)
                2'b01: // Red state
                    begin
                        if (cnt == 0) begin
                            state <= 2'b10; // Transition to green state
                            cnt <= 60; // Green duration
                        end else begin
                            cnt <= cnt - 1;
                        end
                        red <= 1;
                        yellow <= 0;
                        green <= 0;
                    end
                2'b10: // Green state
                    begin
                        if (cnt == 0 || (pass_request && cnt > 10)) begin
                            state <= 2'b11; // Transition to yellow state
                            cnt <= 5; // Yellow duration
                        end else if (pass_request && cnt <= 10) begin
                            // Do nothing, maintain current state and count
                        end else begin
                            cnt <= cnt - 1;
                        end
                        red <= 0;
                        yellow <= 0;
                        green <= 1;
                    end
                2'b11: // Yellow state
                    begin
                        if (cnt == 0) begin
                            state <= 2'b01; // Transition to red state
                            cnt <= 10; // Red duration
                        end else begin
                            cnt <= cnt - 1;
                        end
                        red <= 0;
                        yellow <= 1;
                        green <= 0;
                    end
                default:
                    begin
                        state <= 2'b01;
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