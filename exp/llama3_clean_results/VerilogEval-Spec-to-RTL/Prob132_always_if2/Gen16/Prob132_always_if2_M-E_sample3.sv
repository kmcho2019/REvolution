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
            2'b00: begin // Initial state
                if (cpu_overheated) begin
                    shut_off_computer = 1'b1;
                    state = 2'b01;
                end else if (!arrived) begin
                    keep_driving = ~gas_tank_empty;
                    state = 2'b10;
                end
            end
            2'b01: begin // Computer shut off
                shut_off_computer = 1'b1;
                if (!cpu_overheated) begin
                    state = 2'b00;
                end
            end
            2'b10: begin // Driving
                keep_driving = ~gas_tank_empty;
                if (arrived || gas_tank_empty) begin
                    state = 2'b00;
                end
            end
            default: begin
                state = 2'b00;
            end
        endcase
    end

endmodule