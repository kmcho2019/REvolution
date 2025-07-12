module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding
    localparam idle      = 2'd0;
    localparam s1_red    = 2'd1;
    localparam s2_yellow = 2'd2;
    localparam s3_green  = 2'd3;

    reg [7:0] cnt;
    reg [1:0] state;

    // Next state outputs (combinational)
    reg p_red, p_yellow, p_green;

    // For detecting rising edge of pass_request only when green and cnt>10
    // To avoid repeatedly setting cnt to 10 on multiple clocks while pass_request is high
    reg pass_request_sync1, pass_request_sync2;
    wire pass_request_rising;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pass_request_sync1 <= 1'b0;
            pass_request_sync2 <= 1'b0;
        end else begin
            pass_request_sync1 <= pass_request;
            pass_request_sync2 <= pass_request_sync1;
        end
    end
    assign pass_request_rising = pass_request_sync1 & ~pass_request_sync2;

    // Combinational logic to determine outputs for each state
    always @(*) begin
        p_red    = 1'b0;
        p_yellow = 1'b0;
        p_green  = 1'b0;

        case(state)
            idle: begin
                // All off in idle
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b0;
            end
            s1_red: begin
                p_red = 1'b1;
            end
            s2_yellow: begin
                p_yellow = 1'b1;
            end
            s3_green: begin
                p_green = 1'b1;
            end
            default: begin
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b0;
            end
        endcase
    end

    // State transition logic and counter reload on cnt==0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt   <= 8'd10; // start with red duration on reset release
        end else begin
            case(state)
                idle: begin
                    // immediately go to red state with counter loaded to 10
                    state <= s1_red;
                    cnt   <= 8'd10;
                end
                s1_red: begin
                    if (cnt == 8'd0) begin
                        state <= s3_green;
                        cnt <= 8'd60;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s3_green: begin
                    // Pedestrian button shortens green if remaining > 10 on rising edge of pass_request
                    if (pass_request_rising && (cnt > 8'd10)) begin
                        cnt <= 8'd10;
                    end else if (cnt == 8'd0) begin
                        state <= s2_yellow;
                        cnt <= 8'd5;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s2_yellow: begin
                    if (cnt == 8'd0) begin
                        state <= s1_red;
                        cnt <= 8'd10;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    state <= idle;
                    cnt <= 8'd10;
                end
            endcase
        end
    end

    // Synchronously assign outputs and clock count
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
            clock  <= 8'd0;
        end else begin
            red    <= p_red;
            yellow <= p_yellow;
            green  <= p_green;
            clock  <= cnt;
        end
    end

endmodule