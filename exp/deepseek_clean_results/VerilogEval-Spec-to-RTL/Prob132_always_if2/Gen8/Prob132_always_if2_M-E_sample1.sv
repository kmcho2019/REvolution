module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Priority-encoded control logic
    always @(*) begin
        // Default assignments
        shut_off_computer = 1'b0;
        keep_driving = 1'b0;
        
        // Priority handling
        case (1'b1)
            cpu_overheated: begin
                shut_off_computer = 1'b1;
                keep_driving = 1'b0;  // Safety first - stop driving if overheating
            end
            ~arrived: begin
                keep_driving = ~gas_tank_empty;
            end
            // No default needed as all cases covered by initial assignments
        endcase
    end

endmodule