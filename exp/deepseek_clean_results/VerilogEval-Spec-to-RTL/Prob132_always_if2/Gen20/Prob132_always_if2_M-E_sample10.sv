module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // State encoding
    wire [1:0] state;
    assign state = {~arrived & ~gas_tank_empty, cpu_overheated};

    // Output decoding
    always @(*) begin
        case (state)
            2'b00: begin  // Normal operation
                shut_off_computer = 0;
                keep_driving = 0;
            end
            2'b01: begin  // CPU overheated
                shut_off_computer = 1;
                keep_driving = 0;
            end
            2'b10: begin  // Not arrived with gas
                shut_off_computer = 0;
                keep_driving = 1;
            end
            2'b11: begin  // Not arrived without gas
                shut_off_computer = 1;
                keep_driving = 0;
            end
        endcase
    end

endmodule