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
            2'b00: // normal state
                begin
                    shut_off_computer = 1'b0;
                    keep_driving = ~arrived && ~gas_tank_empty;
                    if (cpu_overheated) begin
                        state = 2'b01; // transition to overheated state
                    end else if (arrived && gas_tank_empty) begin
                        state = 2'b10; // transition to stopped state
                    end
                end
            2'b01: // overheated state
                begin
                    shut_off_computer = 1'b1;
                    keep_driving = 1'b0;
                    if (~cpu_overheated) begin
                        state = 2'b00; // transition back to normal state
                    end
                end
            2'b10: // stopped state
                begin
                    shut_off_computer = 1'b0;
                    keep_driving = 1'b0;
                    if (~arrived || ~gas_tank_empty) begin
                        state = 2'b00; // transition back to normal state
                    end
                end
            default: // default state
                begin
                    shut_off_computer = 1'b0;
                    keep_driving = 1'b0;
                    state = 2'b00; // transition to normal state
                end
        endcase
    end

    initial begin
        state = 2'b00; // initialize to normal state
    end

endmodule