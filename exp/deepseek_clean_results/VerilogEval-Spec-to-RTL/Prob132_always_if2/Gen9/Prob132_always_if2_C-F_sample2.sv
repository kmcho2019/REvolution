module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Default assignments for all outputs
        shut_off_computer = 1'b0;
        keep_driving = 1'b0;
        
        // CPU overheating takes priority
        if (cpu_overheated) begin
            shut_off_computer = 1'b1;
        end
        
        // Driving logic independent of CPU state
        if (~arrived) begin
            keep_driving = ~gas_tank_empty;
        end
    end

endmodule