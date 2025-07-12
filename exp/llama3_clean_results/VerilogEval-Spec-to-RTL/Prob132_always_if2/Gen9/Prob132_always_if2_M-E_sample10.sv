module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state; // 2-bit state variable for 4 states
    parameter IDLE = 2'b00, COMPUTER_ON = 2'b01, DRIVING = 2'b10, COMPUTER_OFF = 2'b11;

    always @(*) begin
        case(state)
            IDLE: begin
                if (!cpu_overheated && !arrived && !gas_tank_empty) begin
                    state = DRIVING;
                    shut_off_computer = 0;
                    keep_driving = 1;
                end else if (cpu_overheated) begin
                    state = COMPUTER_OFF;
                    shut_off_computer = 1;
                    keep_driving = 0;
                end else begin
                    state = IDLE;
                    shut_off_computer = 0;
                    keep_driving = 0;
                end
            end
            COMPUTER_ON: begin
                if (cpu_overheated) begin
                    state = COMPUTER_OFF;
                    shut_off_computer = 1;
                    keep_driving = 0;
                end else begin
                    state = COMPUTER_ON;
                    shut_off_computer = 0;
                    keep_driving = 0;
                end
            end
            DRIVING: begin
                if (arrived || gas_tank_empty) begin
                    state = IDLE;
                    shut_off_computer = 0;
                    keep_driving = 0;
                end else begin
                    state = DRIVING;
                    shut_off_computer = 0;
                    keep_driving = 1;
                end
            end
            COMPUTER_OFF: begin
                if (!cpu_overheated) begin
                    state = COMPUTER_ON;
                    shut_off_computer = 0;
                    keep_driving = 0;
                end else begin
                    state = COMPUTER_OFF;
                    shut_off_computer = 1;
                    keep_driving = 0;
                end
            end
            default: begin
                state = IDLE;
                shut_off_computer = 0;
                keep_driving = 0;
            end
        endcase
    end

    initial begin
        state = IDLE;
        shut_off_computer = 0;
        keep_driving = 0;
    end

endmodule