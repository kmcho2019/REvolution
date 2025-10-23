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
            2'b00: begin // idle state
                shut_off_computer = cpu_overheated;
                keep_driving = arrived? 0 : ~gas_tank_empty;
            end
            2'b01: begin // driving state
                shut_off_computer = 0;
                keep_driving = ~gas_tank_empty;
            end
            2'b10: begin // shut_off state
                shut_off_computer = 1;
                keep_driving = 0;
            end
            default: begin
                shut_off_computer = 0;
                keep_driving = 0;
            end
        endcase
    end

    always @(*) begin
        if (cpu_overheated) begin
            state = 2'b10; // transition to shut_off state
        end else if (arrived) begin
            state = 2'b00; // transition to idle state
        end else if (~gas_tank_empty) begin
            state = 2'b01; // transition to driving state
        end else begin
            state = 2'b00; // default to idle state
        end
    end

endmodule