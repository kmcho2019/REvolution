module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state; // 0: computer on, driving; 1: computer on, stopped; 2: computer off, stopped; 3: computer off, driving (invalid state, should not occur)

    always @(*) begin
        case (state)
            0: begin // Computer on, driving
                if (cpu_overheated) begin
                    state = 2; // Transition to computer off, stopped
                    shut_off_computer = 1;
                    keep_driving = 0;
                end else if (arrived || gas_tank_empty) begin
                    state = 1; // Transition to computer on, stopped
                    shut_off_computer = 0;
                    keep_driving = 0;
                end else begin
                    state = 0; // Remain in computer on, driving
                    shut_off_computer = 0;
                    keep_driving = 1;
                end
            end
            1: begin // Computer on, stopped
                if (cpu_overheated) begin
                    state = 2; // Transition to computer off, stopped
                    shut_off_computer = 1;
                    keep_driving = 0;
                end else if (!arrived && !gas_tank_empty) begin
                    state = 0; // Transition to computer on, driving
                    shut_off_computer = 0;
                    keep_driving = 1;
                end else begin
                    state = 1; // Remain in computer on, stopped
                    shut_off_computer = 0;
                    keep_driving = 0;
                end
            end
            2: begin // Computer off, stopped
                if (!cpu_overheated) begin
                    state = 1; // Transition to computer on, stopped
                    shut_off_computer = 0;
                    keep_driving = 0;
                end else begin
                    state = 2; // Remain in computer off, stopped
                    shut_off_computer = 1;
                    keep_driving = 0;
                end
            end
            default: begin // Invalid state, transition to computer on, stopped
                state = 1;
                shut_off_computer = 0;
                keep_driving = 0;
            end
        endcase
    end

    initial begin
        state = 0; // Initialize to computer on, driving
        shut_off_computer = 0;
        keep_driving = 1;
    end

endmodule