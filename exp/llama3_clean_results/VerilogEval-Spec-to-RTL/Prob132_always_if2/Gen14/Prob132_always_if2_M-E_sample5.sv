module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state;

    always @(*) begin
        case (state)
            2'b00: // IDLE
                begin
                    shut_off_computer = 0;
                    if (cpu_overheated) begin
                        state = 2'b10; // OVERHEATED
                    end else if (!arrived && !gas_tank_empty) begin
                        keep_driving = 1;
                        state = 2'b01; // DRIVING
                    end
                end
            2'b01: // DRIVING
                begin
                    shut_off_computer = 0;
                    keep_driving = 1;
                    if (cpu_overheated) begin
                        state = 2'b10; // OVERHEATED
                    end else if (arrived || gas_tank_empty) begin
                        keep_driving = 0;
                        state = 2'b00; // IDLE
                    end
                end
            2'b10: // OVERHEATED
                begin
                    shut_off_computer = 1;
                    keep_driving = 0;
                    if (!cpu_overheated) begin
                        state = 2'b00; // IDLE
                    end
                end
            2'b11: // STOPPED
                begin
                    shut_off_computer = 1;
                    keep_driving = 0;
                end
            default: ;
        endcase
    end

endmodule