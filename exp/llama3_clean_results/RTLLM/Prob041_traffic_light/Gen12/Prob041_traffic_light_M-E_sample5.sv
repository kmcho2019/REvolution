module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timer Module
module timer(
    input rst_n,
    input clk,
    input [7:0] countdown_value,
    output reg timer_expired
);
    reg [7:0] counter;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            timer_expired <= 0;
        end else if (counter == 0) begin
            counter <= countdown_value;
            timer_expired <= 0;
        end else begin
            counter <= counter - 1;
            timer_expired <= (counter == 1);
        end
    end
endmodule

// State Machine Module
module state_machine(
    input rst_n,
    input clk,
    input timer_expired,
    input pass_request,
    output reg [1:0] state
);
    parameter idle = 2'b00, red = 2'b01, yellow = 2'b10, green = 2'b11;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
        end else begin
            case (state)
                idle: state <= red;
                red: if (timer_expired) state <= green;
                yellow: if (timer_expired) state <= red;
                green: if (timer_expired && pass_request) state <= yellow; else if (timer_expired) state <= yellow;
                default: state <= idle;
            endcase
        end
    end
endmodule

// Output Logic Module
module output_logic(
    input [1:0] state,
    output reg red,
    output reg yellow,
    output reg green
);
    always @(*) begin
        case (state)
            2'b01: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            2'b10: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
            2'b11: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
            default: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
        endcase
    end
endmodule

// Instantiation of Modules
wire timer_expired;
reg [7:0] countdown_value = 60; // Default countdown value
reg [1:0] state;

timer u_timer(
    .rst_n(rst_n),
    .clk(clk),
    .countdown_value(countdown_value),
    .timer_expired(timer_expired)
);

state_machine u_state_machine(
    .rst_n(rst_n),
    .clk(clk),
    .timer_expired(timer_expired),
    .pass_request(pass_request),
    .state(state)
);

output_logic u_output_logic(
    .state(state),
    .red(red),
    .yellow(yellow),
    .green(green)
);

// Assign output clock
assign clock = countdown_value;

endmodule