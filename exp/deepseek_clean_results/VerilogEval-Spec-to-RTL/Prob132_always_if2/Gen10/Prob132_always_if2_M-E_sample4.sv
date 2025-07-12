module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Handle computer shutdown
        shut_off_computer = cpu_overheated;
        
        // Handle driving logic using case statement
        case ({arrived, gas_tank_empty})
            2'b00: keep_driving = 1;  // Not arrived, tank not empty
            2'b01: keep_driving = 0;  // Not arrived, tank empty
            2'b10: keep_driving = 0;  // Arrived, tank not empty
            2'b11: keep_driving = 0;  // Arrived, tank empty
            default: keep_driving = 0; // For simulation robustness
        endcase
    end

endmodule