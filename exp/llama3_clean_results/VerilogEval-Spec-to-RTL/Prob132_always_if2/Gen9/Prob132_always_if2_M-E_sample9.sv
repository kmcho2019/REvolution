module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state; // 0: driving, 1: shutdown

    always @(*) begin
        case (state)
            0: begin // driving
                if (cpu_overheated) begin
                    state = 1;
                    shut_off_computer = 1;
                end else if (arrived || gas_tank_empty) begin
                    keep_driving = 0;
                end else begin
                    keep_driving = 1;
                end
            end
            1: begin // shutdown
                shut_off_computer = 1;
                keep_driving = 0;
            end
            default: begin
                state = 0;
                shut_off_computer = 0;
                keep_driving = 0;
            end
        endcase
    end

    initial begin
        state = 0;
        shut_off_computer = 0;
        keep_driving = 0;
    end

endmodule