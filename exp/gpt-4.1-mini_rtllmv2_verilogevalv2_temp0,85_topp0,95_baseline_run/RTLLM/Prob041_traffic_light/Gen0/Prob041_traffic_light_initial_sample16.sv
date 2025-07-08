module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Parameters for states
localparam idle      = 2'b00;
localparam s1_red    = 2'b01;
localparam s2_yellow = 2'b10;
localparam s3_green  = 2'b11;

// Registers
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// State transition and next light output logic
always @(*) begin
    // Default next state and lights
    p_red    = 1'b0;
    p_yellow = 1'b0;
    p_green  = 1'b0;
    
    case(state)
        idle: begin
            // All lights off, immediately move to s1_red
            p_red = 1'b0;
            p_yellow = 1'b0;
            p_green = 1'b0;
        end
        s1_red: begin
            p_red = 1'b1;
            p_yellow = 1'b0;
            p_green = 1'b0;
        end
        s2_yellow: begin
            p_red = 1'b0;
            p_yellow = 1'b1;
            p_green = 1'b0;
        end
        s3_green: begin
            p_red = 1'b0;
            p_yellow = 1'b0;
            p_green = 1'b1;
        end
        default: begin
            p_red = 1'b0;
            p_yellow = 1'b0;
            p_green = 1'b0;
        end
    endcase
end

// Counter and state machine sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd10; // initialize counter to red time for stability
    end else begin
        case(state)
            idle: begin
                // Immediately transition to s1_red with counter set to red duration
                state <= s1_red;
                cnt <= 8'd10;
            end
            s1_red: begin
                if (cnt == 8'd0) begin
                    state <= s3_green;
                    cnt <= 8'd60;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
            s2_yellow: begin
                if (cnt == 8'd0) begin
                    state <= s1_red;
                    cnt <= 8'd10;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
            s3_green: begin
                // If pass_request active and remaining green time > 10, shorten to 10
                if (pass_request && (cnt > 8'd10)) begin
                    cnt <= 8'd10;
                end else if (cnt == 8'd0) begin
                    state <= s2_yellow;
                    cnt <= 8'd5;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
            default: begin
                state <= idle;
                cnt <= 8'd10;
            end
        endcase
    end
end

// Assign current count to output clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clock <= 8'd0;
    end else begin
        clock <= cnt;
    end
end

// Output lights update registers on clock edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

endmodule