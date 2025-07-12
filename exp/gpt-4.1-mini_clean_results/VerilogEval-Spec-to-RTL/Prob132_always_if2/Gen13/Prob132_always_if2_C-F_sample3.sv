module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Intermediate combinational signals for clarity and optimization
    wire shut_off_w = cpu_overheated;
    wire keep_drive_w = (~arrived) & (~gas_tank_empty);

    always @(*) begin
        shut_off_computer = shut_off_w;
        keep_driving      = keep_drive_w;
    end

endmodule