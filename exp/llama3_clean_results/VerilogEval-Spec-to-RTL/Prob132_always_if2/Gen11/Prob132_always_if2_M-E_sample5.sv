// Define the states of the FSM
`define IDLE 4'd0
`define OVERHEATED 4'd1
`define ARRIVED 4'd2
`define DRIVING 4'd3
`define STOP 4'd4

// Module for the FSM
module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [3:0] state; // Current state of the FSM
    reg [3:0] next_state; // Next state of the FSM

    // Assign default values
    initial begin
        state = `IDLE;
        shut_off_computer = 0;
        keep_driving = 0;
    end

    // Combinational logic to determine the next state
    always @(*) begin
        case(state)
            `IDLE: begin
                if (cpu_overheated) begin
                    next_state = `OVERHEATED;
                end else if (arrived || gas_tank_empty) begin
                    next_state = `STOP;
                end else begin
                    next_state = `DRIVING;
                end
            end
            `OVERHEATED: begin
                if (~cpu_overheated) begin
                    next_state = `IDLE;
                end else begin
                    next_state = `OVERHEATED;
                end
            end
            `ARRIVED: begin
                next_state = `STOP;
            end
            `DRIVING: begin
                if (arrived || gas_tank_empty) begin
                    next_state = `STOP;
                end else if (cpu_overheated) begin
                    next_state = `OVERHEATED;
                end else begin
                    next_state = `DRIVING;
                end
            end
            `STOP: begin
                if (~arrived && ~gas_tank_empty && ~cpu_overheated) begin
                    next_state = `DRIVING;
                end else if (cpu_overheated) begin
                    next_state = `OVERHEATED;
                end else begin
                    next_state = `STOP;
                end
            end
            default: begin
                next_state = `IDLE;
            end
        endcase
    end

    // Sequential logic to update the state
    always @(posedge cpu_overheated or posedge arrived or posedge gas_tank_empty) begin
        state = next_state;
        if (state == `OVERHEATED) begin
            shut_off_computer = 1;
        end else begin
            shut_off_computer = 0;
        end
        if (state == `DRIVING) begin
            keep_driving = 1;
        end else begin
            keep_driving = 0;
        end
    end

endmodule