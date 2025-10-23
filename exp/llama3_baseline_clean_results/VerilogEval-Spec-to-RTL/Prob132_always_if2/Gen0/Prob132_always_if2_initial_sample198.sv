module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        if (cpu_overheated) begin
            shut_off_computer = 1;
            keep_driving = 0; // When CPU is overheated, don't drive
        end else begin
            shut_off_computer = 0;
            if (~arrived) begin
                keep_driving = ~gas_tank_empty; // Keep driving if not arrived and gas tank not empty
            end else begin
                keep_driving = 0; // Stop driving if arrived
            end
        end
    end

endmodule