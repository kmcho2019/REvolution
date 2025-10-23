module traffic_light(
    input rst_n,  // Reset signal (active low)
    input clk,   // Clock signal
    input pass_request,  // Request signal for allowing vehicles to pass
    output [7:0] clock,  // An 8-bit output representing the count value of the internal counter
    output reg red, yellow, green  // Output signals representing the state of the traffic lights
);

// Enumerations for states
parameter red_state = 2'b00, green_state = 2'b01, yellow_state = 2'b10;

// Internal registers for state and counter
reg [1:0] state;
reg [7:0] cnt;

// Next state and counter value logic
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        state <= red_state;
        cnt <= 10;
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
    end
    else
    begin
        case (state)
            red_state:
            begin
                if (cnt == 0)
                begin
                    state <= green_state;
                    cnt <= 60;
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b1;
                end
                else
                begin
                    cnt <= cnt - 1;
                end
            end
            green_state:
            begin
                if (pass_request && cnt > 10)
                begin
                    cnt <= 10;
                end
                else if (cnt == 0)
                begin
                    state <= yellow_state;
                    cnt <= 5;
                    red <= 1'b0;
                    yellow <= 1'b1;
                    green <= 1'b0;
                end
                else
                begin
                    cnt <= cnt - 1;
                end
            end
            yellow_state:
            begin
                if (cnt == 0)
                begin
                    state <= red_state;
                    cnt <= 10;
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
                else
                begin
                    cnt <= cnt - 1;
                end
            end
            default: state <= red_state;
        endcase
    end
end

assign clock = cnt;

endmodule