// Top-level module using a finite state machine
module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Define the states of the finite state machine
    reg [1:0] state;
    parameter IDLE = 2'b00, SHUT_OFF = 2'b01, DRIVE = 2'b10, STOP = 2'b11;

    // Initialize the state to IDLE
    initial state = IDLE;

    // Finite state machine logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (cpu_overheated) begin
                    state = SHUT_OFF;
                end else if (~arrived && ~gas_tank_empty) begin
                    state = DRIVE;
                end else if (arrived || gas_tank_empty) begin
                    state = STOP;
                end
            end
            SHUT_OFF: begin
                if (~cpu_overheated) begin
                    state = IDLE;
                end
            end
            DRIVE: begin
                if (arrived || gas_tank_empty || cpu_overheated) begin
                    if (cpu_overheated) begin
                        state = SHUT_OFF;
                    end else begin
                        state = STOP;
                    end
                end
            end
            STOP: begin
                if (~arrived && ~gas_tank_empty && ~cpu_overheated) begin
                    state = DRIVE;
                end else if (~cpu_overheated) begin
                    state = IDLE;
                end
            end
            default: state = IDLE;
        endcase
    end

    // Output logic based on the current state
    always @(*) begin
        case (state)
            SHUT_OFF: begin
                shut_off_computer = 1;
                keep_driving = 0;
            end
            DRIVE: begin
                shut_off_computer = 0;
                keep_driving = 1;
            end
            default: begin
                shut_off_computer = 0;
                keep_driving = 0;
            end
        endcase
    end

endmodule