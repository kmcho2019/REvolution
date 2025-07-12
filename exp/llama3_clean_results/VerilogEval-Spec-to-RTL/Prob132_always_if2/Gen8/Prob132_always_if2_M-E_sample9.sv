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
                keep_driving = 1'b0;
                if (!arrived &&!gas_tank_empty) begin
                    state = 2'b01; // transition to driving state
                end
            end
            2'b01: begin // driving state
                shut_off_computer = 1'b0;
                keep_driving =!gas_tank_empty;
                if (arrived || gas_tank_empty) begin
                    state = 2'b00; // transition to idle state
                end
            end
            default: begin
                state = 2'b00; // default to idle state
            end
        endcase
    end

    initial begin
        state = 2'b00; // initialize to idle state
    end

endmodule