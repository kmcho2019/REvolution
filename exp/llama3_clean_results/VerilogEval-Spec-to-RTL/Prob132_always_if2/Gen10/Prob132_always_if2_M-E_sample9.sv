// Top-level module
module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Define the states of the FSM
    reg [1:0] state;
    parameter IDLE = 2'b00;
    parameter SAFE_OPERATION = 2'b01;

    // Initialize the state to IDLE
    initial state = IDLE;

    // FSM logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (cpu_overheated) begin
                    state = SAFE_OPERATION;
                    shut_off_computer = 1'b1;
                    keep_driving = 1'b0;
                end else if (!arrived && !gas_tank_empty) begin
                    keep_driving = 1'b1;
                end else begin
                    keep_driving = 1'b0;
                end
            end
            SAFE_OPERATION: begin
                if (!cpu_overheated) begin
                    state = IDLE;
                    shut_off_computer = 1'b0;
                end
            end
            default: begin
                state = IDLE;
            end
        endcase
    end

endmodule