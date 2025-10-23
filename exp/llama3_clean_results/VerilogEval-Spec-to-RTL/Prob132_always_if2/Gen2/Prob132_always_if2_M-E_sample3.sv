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
            2'b00: // normal_operation
                begin
                    shut_off_computer = 0;
                    keep_driving = ~arrived & ~gas_tank_empty;
                    if (cpu_overheated)
                        state = 2'b01; // transition to emergency_shutdown
                end
            2'b01: // emergency_shutdown
                begin
                    shut_off_computer = 1;
                    keep_driving = 0;
                    if (!cpu_overheated)
                        state = 2'b00; // transition back to normal_operation
                end
            default:
                begin
                    shut_off_computer = 0;
                    keep_driving = 0;
                    state = 2'b00; // reset to normal_operation
                end
        endcase
    end

    initial begin
        state = 2'b00; // initialize to normal_operation
    end

endmodule