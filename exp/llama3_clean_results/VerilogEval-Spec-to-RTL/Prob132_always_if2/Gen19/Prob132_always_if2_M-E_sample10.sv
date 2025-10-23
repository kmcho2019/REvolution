module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state; // 0: running, 1: stopped

    always @(*) begin
        case (state)
            0: begin // running state
                if (cpu_overheated) begin
                    shut_off_computer = 1;
                    state = 1; // transition to stopped state
                end else begin
                    shut_off_computer = 0;
                end
            end
            1: begin // stopped state
                if (!cpu_overheated) begin
                    shut_off_computer = 0;
                    state = 0; // transition to running state
                end else begin
                    shut_off_computer = 1;
                end
            end
            default: begin
                shut_off_computer = 0;
                state = 0; // default to running state
            end
        endcase
    end

    always @(*) begin
        if (!arrived &&!gas_tank_empty) begin
            keep_driving = 1;
        end else begin
            keep_driving = 0;
        end
    end

    initial begin
        state = 0; // initialize to running state
    end

endmodule