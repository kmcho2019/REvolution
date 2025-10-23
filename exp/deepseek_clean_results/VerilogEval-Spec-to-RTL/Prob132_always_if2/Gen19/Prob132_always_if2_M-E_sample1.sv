module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Define state encoding
    localparam [1:0] NORMAL = 2'b00,
                     SHUTDOWN = 2'b01,
                     DRIVING = 2'b10,
                     STOPPED = 2'b11;

    reg [1:0] current_state;

    always @(*) begin
        case (current_state)
            NORMAL: begin
                shut_off_computer = 0;
                keep_driving = 0;
                if (cpu_overheated) current_state = SHUTDOWN;
                else if (~arrived) current_state = DRIVING;
                else current_state = STOPPED;
            end
            SHUTDOWN: begin
                shut_off_computer = 1;
                keep_driving = 0;
                current_state = SHUTDOWN; // Stay in shutdown until reset
            end
            DRIVING: begin
                shut_off_computer = 0;
                keep_driving = ~gas_tank_empty;
                if (arrived) current_state = STOPPED;
                else if (cpu_overheated) current_state = SHUTDOWN;
                else current_state = DRIVING;
            end
            STOPPED: begin
                shut_off_computer = 0;
                keep_driving = 0;
                if (~arrived) current_state = DRIVING;
                else if (cpu_overheated) current_state = SHUTDOWN;
                else current_state = STOPPED;
            end
            default: begin
                shut_off_computer = 0;
                keep_driving = 0;
                current_state = NORMAL;
            end
        endcase
    end

    // Initialize state
    initial begin
        current_state = NORMAL;
        shut_off_computer = 0;
        keep_driving = 0;
    end

endmodule