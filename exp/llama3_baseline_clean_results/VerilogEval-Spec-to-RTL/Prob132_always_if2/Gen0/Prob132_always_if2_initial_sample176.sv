module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        if (cpu_overheated) begin
            shut_off_computer = 1'b1;
            keep_driving = 1'b0;  // We can't drive if the CPU is overheated
        end else begin
            shut_off_computer = 1'b0;
            if (~arrived) begin
                keep_driving = ~gas_tank_empty;
            end else begin
                keep_driving = 1'b0;  // We don't need to drive if we have arrived
            end
        end
    end

endmodule