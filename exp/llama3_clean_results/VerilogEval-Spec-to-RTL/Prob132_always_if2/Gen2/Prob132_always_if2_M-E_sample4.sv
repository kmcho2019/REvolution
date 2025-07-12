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
            2'b00: begin // Normal state
                shut_off_computer = 0;
                if (~arrived)
                    keep_driving = ~gas_tank_empty;
                else
                    keep_driving = 0;
            end
            2'b01: begin // Overheated state
                shut_off_computer = 1;
                keep_driving = 0;
            end
            default: begin
                shut_off_computer = 0;
                keep_driving = 0;
            end
        endcase

        if (cpu_overheated)
            state = 2'b01; // Transition to overheated state
        else
            state = 2'b00; // Transition to normal state
    end

endmodule