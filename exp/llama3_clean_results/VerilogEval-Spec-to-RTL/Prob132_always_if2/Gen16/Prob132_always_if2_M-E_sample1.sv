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
            2'b00: begin // normal state
                if (cpu_overheated)
                    state = 2'b01; // transition to overheated state
                else if (~arrived && ~gas_tank_empty)
                    keep_driving = 1'b1;
                else
                    keep_driving = 1'b0;
            end
            2'b01: begin // overheated state
                shut_off_computer = 1'b1;
                keep_driving = 1'b0;
                if (~cpu_overheated)
                    state = 2'b00; // transition back to normal state
            end
            default: begin
                state = 2'b00; // default to normal state
                keep_driving = 1'b0;
                shut_off_computer = 1'b0;
            end
        endcase
    end

    initial begin
        state = 2'b00; // initialize to normal state
        shut_off_computer = 1'b0;
        keep_driving = 1'b0;
    end

endmodule