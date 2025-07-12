module traffic_light(
    input rst_n,  // Reset signal (active low)
    input clk,   // Clock signal
    input pass_request,  // Request signal for allowing vehicles to pass
    output [7:0] clock,  // An 8-bit output representing the count value of the internal counter
    output reg red, yellow, green  // Output signals representing the state of the traffic lights
);

// Enumerations for states
parameter idle = 2'b00, red_state = 2'b01, green_state = 2'b10, yellow_state = 2'b11;

// Internal registers for state and counter
reg [1:0] state;
reg [7:0] cnt;

// Counter module
module counter(
    input [1:0] state,
    input pass_request,
    output reg [7:0] cnt
);

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        cnt <= 10;
    end
    else
    begin
        case (state)
            idle:
            begin
                cnt <= 10;
            end
            red_state:
            begin
                if (cnt == 0)
                begin
                    cnt <= 60;
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
                    cnt <= 5;
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
                    cnt <= 10;
                end
                else
                begin
                    cnt <= cnt - 1;
                end
            end
            default:
            begin
                cnt <= 10;
            end
        endcase
    end
end

endmodule

// State machine module
module state_machine(
    input [1:0] state,
    input [7:0] cnt,
    output reg [1:0] next_state
);

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        next_state <= idle;
    end
    else
    begin
        case (state)
            idle:
            begin
                next_state <= red_state;
            end
            red_state:
            begin
                if (cnt == 0)
                begin
                    next_state <= green_state;
                end
                else
                begin
                    next_state <= red_state;
                end
            end
            green_state:
            begin
                if (cnt == 0)
                begin
                    next_state <= yellow_state;
                end
                else
                begin
                    next_state <= green_state;
                end
            end
            yellow_state:
            begin
                if (cnt == 0)
                begin
                    next_state <= red_state;
                end
                else
                begin
                    next_state <= yellow_state;
                end
            end
            default:
            begin
                next_state <= idle;
            end
        endcase
    end
end

endmodule

// Output signal generation module
module output_signals(
    input [1:0] state,
    output reg red, yellow, green
);

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end
    else
    begin
        case (state)
            idle:
            begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            red_state:
            begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            green_state:
            begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
            yellow_state:
            begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            default:
            begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
        endcase
    end
end

endmodule

// Instantiation of sub-modules
counter counter_module(
    .state(state),
    .pass_request(pass_request),
    .cnt(cnt)
);

state_machine state_machine_module(
    .state(state),
    .cnt(cnt),
    .next_state(state)
);

output_signals output_signals_module(
    .state(state),
    .red(red),
    .yellow(yellow),
    .green(green)
);

assign clock = cnt;

endmodule