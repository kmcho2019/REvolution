module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Default outputs
        shut_off_computer = 0;
        keep_driving = 0;
        
        case ({cpu_overheated, arrived, gas_tank_empty})
            3'b100: begin
                shut_off_computer = 1;
                keep_driving = 0;
            end
            3'b101: begin
                shut_off_computer = 1;
                keep_driving = 0;
            end
            3'b000: keep_driving = 1;
            3'b001: keep_driving = 0;
            default: begin
                shut_off_computer = cpu_overheated;
                keep_driving = ~arrived & ~gas_tank_empty;
            end
        endcase
    end

endmodule