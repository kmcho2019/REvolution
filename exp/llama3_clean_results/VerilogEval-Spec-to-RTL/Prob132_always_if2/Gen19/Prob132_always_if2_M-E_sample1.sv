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
            2'b00: begin // running
                if (cpu_overheated) begin
                    state = 2'b01; // shut_off
                    shut_off_computer = 1;
                end else begin
                    shut_off_computer = 0;
                end
                if (~arrived && !gas_tank_empty) begin
                    keep_driving = 1;
                end else begin
                    keep_driving = 0;
                end
            end
            2'b01: begin // shut_off
                shut_off_computer = 1;
                keep_driving = 0;
            end
            default: begin
                state = 2'b00; // running
                shut_off_computer = 0;
                keep_driving = 0;
            end
        endcase
    end

endmodule