module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        case ({cpu_overheated, arrived, gas_tank_empty})
            3'b000: begin
                shut_off_computer = 0;
                keep_driving = 1;
            end
            3'b001: begin
                shut_off_computer = 0;
                keep_driving = 0;
            end
            3'b010: begin
                shut_off_computer = 0;
                keep_driving = 0;
            end
            3'b011: begin
                shut_off_computer = 0;
                keep_driving = 0;
            end
            3'b100: begin
                shut_off_computer = 1;
                keep_driving = 1;
            end
            3'b101: begin
                shut_off_computer = 1;
                keep_driving = 0;
            end
            3'b110: begin
                shut_off_computer = 1;
                keep_driving = 0;
            end
            3'b111: begin
                shut_off_computer = 1;
                keep_driving = 0;
            end
            default: begin
                shut_off_computer = 0;
                keep_driving = 0;
            end
        endcase
    end

endmodule