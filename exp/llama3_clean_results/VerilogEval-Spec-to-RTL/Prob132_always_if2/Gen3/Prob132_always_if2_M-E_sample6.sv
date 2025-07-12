module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state; // 2-bit register to hold the current state

    always @(*) begin
        case(state)
            2'b00: // Computer is on and driving is allowed
                if (cpu_overheated) begin
                    shut_off_computer = 1;
                    state = 2'b10; // Transition to computer off and driving allowed
                end else if (arrived || gas_tank_empty) begin
                    keep_driving = 0;
                    state = 2'b01; // Transition to computer on but driving not allowed
                end else begin
                    shut_off_computer = 0;
                    keep_driving = 1;
                end

            2'b01: // Computer is on but driving is not allowed
                if (cpu_overheated) begin
                    shut_off_computer = 1;
                    state = 2'b11; // Transition to computer off and driving not allowed
                end else if (!arrived && !gas_tank_empty) begin
                    keep_driving = 1;
                    state = 2'b00; // Transition to computer on and driving allowed
                end else begin
                    shut_off_computer = 0;
                    keep_driving = 0;
                end

            2'b10: // Computer is off and driving is allowed
                if (!cpu_overheated) begin
                    shut_off_computer = 0;
                    state = 2'b00; // Transition to computer on and driving allowed
                end else if (arrived || gas_tank_empty) begin
                    keep_driving = 0;
                    state = 2'b11; // Transition to computer off and driving not allowed
                end else begin
                    shut_off_computer = 1;
                    keep_driving = 1;
                end

            2'b11: // Computer is off and driving is not allowed
                if (!cpu_overheated) begin
                    shut_off_computer = 0;
                    state = 2'b01; // Transition to computer on but driving not allowed
                end else begin
                    shut_off_computer = 1;
                    keep_driving = 0;
                end

            default:
                shut_off_computer = 0;
                keep_driving = 1;
                state = 2'b00; // Default to computer on and driving allowed
        endcase
    end

    initial begin
        shut_off_computer = 0;
        keep_driving = 1;
        state = 2'b00; // Initialize to computer on and driving allowed
    end

endmodule