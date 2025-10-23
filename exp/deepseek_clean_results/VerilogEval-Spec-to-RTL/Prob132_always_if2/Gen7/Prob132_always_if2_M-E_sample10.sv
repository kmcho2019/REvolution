module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Priority-encoded with explicit defaults
    always @(*) begin
        shut_off_computer = 1'b0;  // Default value
        if (cpu_overheated) begin
            shut_off_computer = 1'b1;
        end
    end

    always @(*) begin
        keep_driving = 1'b0;  // Default when arrived
        if (~arrived) begin
            keep_driving = ~gas_tank_empty;
        end
    end

endmodule