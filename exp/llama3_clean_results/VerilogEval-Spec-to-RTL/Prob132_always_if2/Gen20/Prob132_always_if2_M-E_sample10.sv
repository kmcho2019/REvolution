module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Define states for the FSM
    enum logic [1:0] {
        IDLE,
        OVERHEATED,
        DRIVING,
        STOPPED
    } state, next_state;

    // Current state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (cpu_overheated) begin
                    next_state = OVERHEATED;
                end else if (~arrived && ~gas_tank_empty) begin
                    next_state = DRIVING;
                end else if (arrived || gas_tank_empty) begin
                    next_state = STOPPED;
                end else begin
                    next_state = IDLE;
                end
            end
            OVERHEATED: begin
                next_state = OVERHEATED; // Stay in this state once entered
            end
            DRIVING: begin
                if (arrived || gas_tank_empty) begin
                    next_state = STOPPED;
                end else if (cpu_overheated) begin
                    next_state = OVERHEATED;
                end else begin
                    next_state = DRIVING;
                end
            end
            STOPPED: begin
                if (~arrived && ~gas_tank_empty) begin
                    next_state = DRIVING;
                end else if (cpu_overheated) begin
                    next_state = OVERHEATED;
                end else begin
                    next_state = STOPPED;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic to update state
    always @(posedge cpu_overheated or posedge arrived or posedge gas_tank_empty) begin
        state <= next_state;
    end

    // Output logic based on state
    always @(*) begin
        case (state)
            IDLE: begin
                shut_off_computer = 0;
                keep_driving = ~arrived && ~gas_tank_empty;
            end
            OVERHEATED: begin
                shut_off_computer = 1;
                keep_driving = 0;
            end
            DRIVING: begin
                shut_off_computer = 0;
                keep_driving = 1;
            end
            STOPPED: begin
                shut_off_computer = 0;
                keep_driving = 0;
            end
            default: begin
                shut_off_computer = 0;
                keep_driving = 0;
            end
        endcase
    end

endmodule